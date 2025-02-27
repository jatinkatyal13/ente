package controller

import (
	"context"
	"sync"

	"github.com/ente-io/museum/ente"
	"github.com/ente-io/museum/pkg/controller/storagebonus"
	"github.com/ente-io/museum/pkg/controller/usercache"
	"github.com/ente-io/museum/pkg/repo"
	"github.com/ente-io/stacktrace"
)

// UsageController exposes functions which can be used to check around storage
type UsageController struct {
	mu                sync.Mutex
	StorageBonusCtrl  *storagebonus.Controller
	UserCacheCtrl     *usercache.Controller
	UsageRepo         *repo.UsageRepository
	UserRepo          *repo.UserRepository
	FamilyRepo        *repo.FamilyRepository
	FileRepo          *repo.FileRepository
	UploadResultCache map[int64]bool
}

const MaxLockerFiles = 10000
const hundredMBInBytes = 100 * 1024 * 1024

// CanUploadFile returns error if the file of given size (with StorageOverflowAboveSubscriptionLimit buffer) can be
// uploaded or not. If size is not passed, it validates if current usage is less than subscription storage.
func (c *UsageController) CanUploadFile(ctx context.Context, userID int64, size *int64, app ente.App) error {
	// check if size is nil or less than 100 MB
	if app != ente.Locker && (size == nil || *size < hundredMBInBytes) {
		c.mu.Lock()
		canUpload, ok := c.UploadResultCache[userID]
		c.mu.Unlock()
		if ok && canUpload {
			go func() {
				_ = c.checkAndUpdateCache(ctx, userID, size, app)
			}()
			return nil
		}
	}
	return c.checkAndUpdateCache(ctx, userID, size, app)
}

func (c *UsageController) checkAndUpdateCache(ctx context.Context, userID int64, size *int64, app ente.App) error {
	err := c.canUploadFile(ctx, userID, size, app)
	c.mu.Lock()
	c.UploadResultCache[userID] = err == nil
	c.mu.Unlock()
	return err
}

func (c *UsageController) canUploadFile(ctx context.Context, userID int64, size *int64, app ente.App) error {
	// If app is Locker, limit to MaxLockerFiles files
	if app == ente.Locker {
		// Get file count
		if fileCount, err := c.UserCacheCtrl.GetUserFileCountWithCache(userID, app); err != nil {
			if fileCount >= MaxLockerFiles {
				return stacktrace.Propagate(ente.ErrFileLimitReached, "")
			}
		}
	}

	return nil
}
