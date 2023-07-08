import type { Site, SocialObjects } from "./types";

export const SITE: Site = {
    website: "https://aj.codes",
    author: "Andrew Jorgensen",
    desc: "My blog",
    title: "Andrew Jorgensen",
    ogImage: "astropaper-og.jpg",
    lightAndDarkMode: true,
    postPerPage: 25,
};

export const LOCALE = ["en-EN"]; // set to [] to use the environment default

export const LOGO_IMAGE = {
    enable: false,
    svg: true,
    width: 216,
    height: 46,
};

export const SOCIALS: SocialObjects = [
    {
        name: "Github",
        href: "https://github.com/ajorgensen",
        linkTitle: ` ${SITE.title} on Github`,
        active: true,
    },
    {
        name: "Twitter",
        href: "https://twitter.com/ajorgensen",
        linkTitle: `${SITE.title} on Twitter`,
        active: true,
    },
];
