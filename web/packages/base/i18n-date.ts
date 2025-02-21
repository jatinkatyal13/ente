/**
 * @file Various date formatters.
 *
 * Note that we rely on the current behaviour of a full reload on changing the
 * language. See: [Note: Changing locale causes a full reload].
 */
import i18n from "i18next";

const _dateFormat = new Intl.DateTimeFormat(i18n.language, {
    weekday: "short",
    day: "numeric",
    month: "short",
    year: "numeric",
});

const _dateWithoutYearFormat = new Intl.DateTimeFormat(i18n.language, {
    weekday: "short",
    day: "numeric",
    month: "short",
});

const _timeFormat = new Intl.DateTimeFormat(i18n.language, {
    timeStyle: "short",
});

/**
 * Return a locale aware formatted date from the given {@link Date}.
 *
 * Example: "Fri, 21 Feb 2025"
 */
export const formattedDate = (date: Date) => _dateFormat.format(date);

/**
 * A variant of {@link formattedDate} that omits the year.
 *
 * Example: "Fri, 21 Feb"
 */
export const formattedDateWithoutYear = (date: Date) =>
    _dateWithoutYearFormat.format(date);

/**
 * Return a locale aware formatted time from the given {@link Date}.
 *
 * Example: "11:51 AM"
 */
export const formattedTime = (date: Date) => _timeFormat.format(date);

let _relativeTimeFormat: Intl.RelativeTimeFormat | undefined;

export const formattedDateRelative = (date: Date) => {
    const units: [Intl.RelativeTimeFormatUnit, number][] = [
        ["year", 24 * 60 * 60 * 1000 * 365],
        ["month", (24 * 60 * 60 * 1000 * 365) / 12],
        ["day", 24 * 60 * 60 * 1000],
        ["hour", 60 * 60 * 1000],
        ["minute", 60 * 1000],
        ["second", 1000],
    ];

    // Math.abs accounts for both past and future scenarios.
    const elapsed = Math.abs(date.getTime() - Date.now());

    // Lazily created, then cached, instance of RelativeTimeFormat.
    const relativeTimeFormat = (_relativeTimeFormat ??=
        new Intl.RelativeTimeFormat(i18n.language, {
            localeMatcher: "best fit",
            numeric: "always",
            style: "short",
        }));

    for (const [u, d] of units) {
        if (elapsed > d)
            return relativeTimeFormat.format(Math.round(elapsed / d), u);
    }

    return relativeTimeFormat.format(Math.round(elapsed / 1000), "second");
};
