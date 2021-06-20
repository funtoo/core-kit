#!/usr/bin/env python3

import json


async def generate(hub, **pkginfo):

	github_user = "flatpak"
	github_repo = "flatpak"
	app = pkginfo["name"]
	json_list = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{github_user}/{github_repo}/releases", is_json=True
	)
	for release in sorted(json_list, reverse=True, key=lambda x: x["created_at"]):
		if release["prerelease"] or release["draft"]:
			continue
		version = release["tag_name"].replace("v", "")
		url = f"https://github.com/{github_user}/{github_repo}/releases/download/{version}/{app}-{version}.tar.xz"
		break

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
	)
	ebuild.push()


# vim: ts=4 sw=4 noet
