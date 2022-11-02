#!/usr/bin/env python3
from bs4 import BeautifulSoup
import re

async def get_latest_release(hub, **pkginfo):
    html = await hub.pkgtools.fetch.get_page("https://jfs.sourceforge.net/source.html#latesrc")

    for a in BeautifulSoup(html, features="html.parser").find_all("a", href=True):
        v = re.search("(?<=jfsutils-)\d+\.\d+\.\d+(?=\.tar\.gz)", a["href"])
        if v is not None:
            return v.group(0)
    raise KeyError(f"Unable to find a tarball for {pkginfo['name']}")

async def generate(hub, **pkginfo):
    version = await get_latest_release(hub, **pkginfo)

    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        version=version,
        artifacts=[hub.pkgtools.ebuild.Artifact(url=f"https://jfs.sourceforge.net/project/pub/jfsutils-{version}.tar.gz")],
    )

    ebuild.push()
