const core = require("@actions/core");
const fs = require("fs").promises;
const glob = require("@actions/glob");

async function enter() {
    const packageData = JSON.parse(fs.readFile("package.json", "utf-8"));
    const baseVersion = pacakgeData.version;

    core.info(`Found base version ${baseVersion}`);

    const match = /([0-9]+)\.([0-9]+)\.([0-9]+)(-[^+]+)?(\+.*)?$/.exec(
        baseVersion
    );
    const [, major, minor, patch, preRelease, meta] = match;
    core.info("Found these:", { major, minor, patch, preRelease, meta });
}

async function main() {
    try {
        await enter();
    } catch (error) {
        core.setFailed(error.message);
    }
}

main();
