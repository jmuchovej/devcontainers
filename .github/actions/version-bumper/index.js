const core = require("@actions/core");
const axios = require("axios").default;
const semver = require("semver");


// Conda API docs: https://api.anaconda.org/docs
// Conda API, getting version info: https://api.anaconda.org/docs#/package/get_package__owner_login___package_name_

const API_URL = "https://api.anaconda.org";

const makeURL = (package_owner, package_name) => `${API_URL}/package/${package_owner}/${package_name}`;

const getVersions = async (URL) => {
    const { data: { files } } = await axios.get(URL);
    const linux = files
        .filter(f => f.attrs.platform == "linux")
        .map(f => `${f.version}+${f.attrs.build_number}`);
    const uniq = [...new Set(linux)];
    const parsed = uniq.map(semver.parse).filter(e => e);
    return parsed; 
}

const getLatest = async (pkg_owner, pkg_name) => {
    const url = makeURL(pkg_owner, pkg_name);
    const versions = await getVersions(url);
    const latest = semver.rsort(versions)[0];
    return { version: latest.version, build_n: latest.build[0] };
}

async function run() {
    try {
        const pkg_owner = core.getInput("owner");
        const pkg_name = core.getInput("package");
    
        const conda_latest = await getLatest("conda-forge", "conda");
        core.setOutput("conda_version", conda_latest.version);
        core.setOutput("conda_build_n", conda_latest.build_n);
    
        const pkg_latest = await getLatest(pkg_owner, pkg_name);
        if (pkg_latest) {
            core.setOutput("pkg_version", pkg_latest.version);
            core.setOutput("pkg_build_n", pkg_latest.build_n);
        } else {
    	core.setFailed(`Failed to find valid version for \`${pkg_owner}/${pkg_name}\``)
        }
    } catch (error) {
        core.setFailed(error.message)
    }
};

run();
