#!/usr/bin/env python3


def get_release(release_data):
    releases = list(filter(
        lambda x: x["prerelease"] is False and x["draft"] is False,
        release_data
    ))
    return None if not releases else sorted(releases, key=lambda x: x["tag_name"]).pop()


async def generate(hub, **pkginfo):
    repo = pkginfo["name"]
    releases_data = await hub.pkgtools.fetch.get_page(
        f"https://api.github.com/repos/{repo}/{repo}/releases",
        is_json=True
    )
    latest_release = get_release(releases_data)
    if latest_release is None:
        raise hub.pkgtools.ebuild.BreezyError(
            f"Can't find a suitable release of {repo}")
    version = latest_release["tag_name"]
    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        version=version.lstrip("v"),
        artifacts=[
            hub.pkgtools.ebuild.Artifact(
                url=f"https://github.com/{repo}/{repo}/archive/{version}.tar.gz"
            )
        ]
    )
    ebuild.push()
