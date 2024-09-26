#!/usr/bin/env python3

from bs4 import BeautifulSoup
import re

async def generate(hub, **pkginfo):
	html_data = await hub.pkgtools.fetch.get_page("http://git-scm.com/downloads/linux")
	soup = BeautifulSoup(html_data, "html.parser")
	archives = {}
	for link in soup.find_all("a", href=True):
		href = link.get("href")
		if href is not None and href.endswith(".tar.gz"):
			latest = re.search('(https.*)/git-([0-9].*)\.tar\.gz', href)
			kernel_org = latest.group(1)
			version = latest.group(2)
			break
	src_artifact = hub.pkgtools.ebuild.Artifact(url=f"{kernel_org}/git-{version}.tar.xz")
	artifacts = [
		src_artifact,
		hub.pkgtools.ebuild.Artifact(url=f"{kernel_org}/git-manpages-{version}.tar.xz"),
	]
	ebuild = hub.pkgtools.ebuild.BreezyBuild(**pkginfo, version=version, artifacts=artifacts)
	ebuild.push()


# vim: ts=4 sw=4 noet
