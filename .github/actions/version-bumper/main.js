const core = require('@actions/core');
const axios = require("axios").default;
const semver = require("semver");


// Conda API docs: https://api.anaconda.org/docs
// Conda API, getting version info: https://api.anaconda.org/docs#/package/get_package__owner_login___package_name_

const API_URL = "https://api.anaconda.org";

const makeURL = (owner, package) => `${API_URL}/package/${owner}/${package}`;

const getVersions = async (URL) => {
    const { data: { files } } = await axios.get(URL);
    const linux = files
        .filter(f => f.attrs.platform == "linux")
        .map(f => `${f.version}+${f.attrs.build_number}`);
    const uniq = [...new Set(linux)];
    const parsed = uniq.map(semver.parse).filter(e => e);
    return parsed; 
}

const getLatest = async (owner, package) => {
    const url = makeURL(owner, package)
    const versions = await getVerions(url)
    const latest = semver.rsort(versions)[0];
    return { version: latest.version, build_n: latest.build[0] };
}

try {
    const owner = core.getInput("owner");
    const package = core.getInput("package");

    const pkg_latest = await getLatest(owner, package);
    const conda_latest = await getLatest("conda-forge", "conda");

    if (latest) {
        core.setOutput("conda_version", conda_latest.version)
        core.setOutput("conda_build_n", conda_latest.build_n)
        core.setOutput("pkg_version", pkg_latest.version)
        core.setOutput("pkg_build_n", pkg_latest.build_n)
    } else {
	core.setFailed(`Failed to find valid version for \`${owner}/${package}\``)
    }
} catch (error) {
    core.setFailed(error.message)
}
