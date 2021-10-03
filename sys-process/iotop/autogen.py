#!/usr/bin/env python3

from packaging import version


async def generate(hub, **pkginfo):
	github_user = "Tomas-M"
	github_repo = pkginfo.get("name")

	release_data = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{github_user}/{github_repo}/releases",
		is_json=True,
	)

	try:
		latest_release = max(
			(
				release
				for release in release_data
				if not release["prerelease"] and not release["draft"]
			),
			key=lambda release: version.parse(release["tag_name"]),
		)
	except ValueError:
		raise hub.pkgtools.ebuild.BreezyError(
			f"Can't find suitable release of {github_repo}"
		)

	tag_name = latest_release["tag_name"]
	latest_version = tag_name.lstrip("v")

	source_name = f"{github_repo}-{latest_version}.tar.xz"
	source_asset = next(
		asset for asset in latest_release["assets"] if asset["name"] == source_name
	)

	source_url = source_asset["browser_download_url"]

	source_artifact = hub.pkgtools.ebuild.Artifact(url=source_url)

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo, version=latest_version, artifacts=[source_artifact]
	)
	ebuild.push()
