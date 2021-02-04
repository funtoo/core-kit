#!/usr/bin/env python3

import json


async def generate(hub, **pkginfo):

	github_user = "sudo-project"
	github_repo = "sudo"
	app = pkginfo["name"]
	json_list = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{github_user}/{github_repo}/releases", is_json=True
	)
	for release in json_list:
		if release["prerelease"] or release["draft"]:
			continue
		version = release["tag_name"].replace("SUDO_", "").replace("_", ".")
		url = f"https://www.sudo.ws/sudo/dist/{app}-{version}.tar.gz"
		break

	version = version.replace("p", "_p")
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=f"{app}-{version}.tar.gz")],
	)
	ebuild.push()


# vim: ts=4 sw=4 noet
