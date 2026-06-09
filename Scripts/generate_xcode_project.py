#!/usr/bin/env python3
"""Generate ScienceBowlCoach.xcodeproj/project.pbxproj"""

import uuid
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
NAME = "ScienceBowlCoach"
BUNDLE = "com.farahrasheed.ScienceBowlCoach"

def u():
    return uuid.uuid4().hex[:24].upper()

swift_files = sorted(p for p in ROOT.rglob("*.swift") if ".xcodeproj" not in str(p))
json_files = sorted(p for p in ROOT.glob("Resources/StudyContent/*.json"))

ids = {k: u() for k in [
    "project", "target", "product", "main_group", "products_group",
    "sources", "resources", "frameworks", "proj_configs", "tgt_configs",
    "debug_proj", "release_proj", "debug_tgt", "release_tgt", "assets", "resources_group"
]}

file_map = {}
for sf in swift_files:
    rel = sf.relative_to(ROOT).as_posix()
    file_map[rel] = {"ref": u(), "build": u()}

resource_map = {}
for jf in json_files:
    rel = jf.relative_to(ROOT).as_posix()
    resource_map[rel] = {"ref": u(), "build": u()}

assets_build = u()
lines = []

def o(s=""):
    lines.append(s)

o("// !$*UTF8*$!")
o("{")
o("\tarchiveVersion = 1;")
o("\tclasses = {};")
o("\tobjectVersion = 56;")
o("\tobjects = {")
o("")
o("/* Begin PBXBuildFile section */")
for rel, fm in file_map.items():
    o(f'\t\t{fm["build"]} /* {Path(rel).name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fm["ref"]} /* {Path(rel).name} */; }};')
o(f'\t\t{assets_build} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {ids["assets"]} /* Assets.xcassets */; }};')
for rel, rm in resource_map.items():
    o(f'\t\t{rm["build"]} /* {Path(rel).name} in Resources */ = {{isa = PBXBuildFile; fileRef = {rm["ref"]} /* {Path(rel).name} */; }};')
o("/* End PBXBuildFile section */")
o("")
o("/* Begin PBXFileReference section */")
o(f'\t\t{ids["product"]} /* {NAME}.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = {NAME}.app; sourceTree = BUILT_PRODUCTS_DIR; }};')
for rel, fm in file_map.items():
    o(f'\t\t{fm["ref"]} /* {Path(rel).name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{rel}"; sourceTree = "<group>"; }};')
o(f'\t\t{ids["assets"]} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Resources/Assets.xcassets; sourceTree = "<group>"; }};')
for rel, rm in resource_map.items():
    o(f'\t\t{rm["ref"]} /* {Path(rel).name} */ = {{isa = PBXFileReference; lastKnownFileType = text.json; path = "{rel}"; sourceTree = "<group>"; }};')
o("/* End PBXFileReference section */")
o("")
o("/* Begin PBXFrameworksBuildPhase section */")
o(f'\t\t{ids["frameworks"]} /* Frameworks */ = {{isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; }};')
o("/* End PBXFrameworksBuildPhase section */")
o("")
o("/* Begin PBXGroup section */")
o(f'\t\t{ids["main_group"]} = {{isa = PBXGroup; children = ({ids["resources_group"]} /* Resources */, {ids["products_group"]} /* Products */); sourceTree = "<group>"; }};')
o(f'\t\t{ids["products_group"]} = {{isa = PBXGroup; children = ({ids["product"]} /* {NAME}.app */); name = Products; sourceTree = "<group>"; }};')
resource_children = [f'{ids["assets"]} /* Assets.xcassets */'] + [f'{rm["ref"]} /* {Path(rel).name} */' for rel, rm in resource_map.items()]
o(f'\t\t{ids["resources_group"]} = {{isa = PBXGroup; children = ({", ".join(resource_children)}); name = Resources; sourceTree = "<group>"; }};')
o("/* End PBXGroup section */")
o("")
o("/* Begin PBXNativeTarget section */")
o(f'\t\t{ids["target"]} /* {NAME} */ = {{')
o("\t\t\tisa = PBXNativeTarget;")
o(f'\t\t\tbuildConfigurationList = {ids["tgt_configs"]};')
o(f'\t\t\tbuildPhases = ({ids["sources"]} /* Sources */, {ids["frameworks"]} /* Frameworks */, {ids["resources"]} /* Resources */);')
o("\t\t\tbuildRules = (); dependencies = ();")
o(f'\t\t\tname = {NAME}; productName = {NAME};')
o(f'\t\t\tproductReference = {ids["product"]}; productType = "com.apple.product-type.application";')
o("\t\t};")
o("/* End PBXNativeTarget section */")
o("")
o("/* Begin PBXProject section */")
o(f'\t\t{ids["project"]} /* Project object */ = {{')
o("\t\t\tisa = PBXProject;")
o("\t\t\tattributes = {BuildIndependentTargetsInParallel = 1; LastSwiftUpdateCheck = 1500; LastUpgradeCheck = 1500;};")
o(f'\t\t\tbuildConfigurationList = {ids["proj_configs"]};')
o('\t\t\tcompatibilityVersion = "Xcode 14.0"; developmentRegion = en; hasScannedForEncodings = 0;')
o('\t\t\tknownRegions = (en, Base);')
o(f'\t\t\tmainGroup = {ids["main_group"]}; productRefGroup = {ids["products_group"]};')
o('\t\t\tprojectDirPath = ""; projectRoot = "";')
o(f'\t\t\ttargets = ({ids["target"]} /* {NAME} */);')
o("\t\t};")
o("/* End PBXProject section */")
o("")
o("/* Begin PBXResourcesBuildPhase section */")
resource_builds = [assets_build] + [rm["build"] for rm in resource_map.values()]
o(f'\t\t{ids["resources"]} = {{isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = ({", ".join(f"{b} /* Resource */" for b in resource_builds)}); runOnlyForDeploymentPostprocessing = 0; }};')
o("/* End PBXResourcesBuildPhase section */")
o("")
o("/* Begin PBXSourcesBuildPhase section */")
o(f'\t\t{ids["sources"]} = {{isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (')
for rel, fm in file_map.items():
    o(f'\t\t\t{fm["build"]} /* {Path(rel).name} */,')
o("\t\t); runOnlyForDeploymentPostprocessing = 0; };")
o("/* End PBXSourcesBuildPhase section */")
o("")
o("/* Begin XCBuildConfiguration section */")

def write_config(cid, name, target=False):
    o(f'\t\t{cid} /* {name} */ = {{isa = XCBuildConfiguration; buildSettings = {{')
    if target:
        o('\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;')
        o('\t\t\t\tCODE_SIGN_STYLE = Automatic; CURRENT_PROJECT_VERSION = 1;')
        o('\t\t\t\tGENERATE_INFOPLIST_FILE = YES;')
        o('\t\t\t\tINFOPLIST_KEY_CFBundleDisplayName = "Science Bowl Coach";')
        o('\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;')
        o('\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;')
        o('\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations = UIInterfaceOrientationPortrait;')
        o('\t\t\t\tINFOPLIST_KEY_NSLocalNetworkUsageDescription = "Connect iPhone buzzer to Mac drill on the same Wi-Fi network.";')
        o('\t\t\t\tINFOPLIST_KEY_NSBonjourServices = _sbcoachbuzz;')
        o('\t\t\t\tINFOPLIST_KEY_LSMinimumSystemVersion = 14.0;')
        o('\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;')
        o('\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 14.0;')
        o('\t\t\t\tLD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/Frameworks");')
        o('\t\t\t\tMARKETING_VERSION = 1.1.0;')
        o(f'\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = {BUNDLE};')
        o('\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)"; SWIFT_EMIT_LOC_STRINGS = YES; SWIFT_VERSION = 5.0;')
        o('\t\t\t\tSDKROOT = auto;')
        o('\t\t\t\tSUPPORTED_PLATFORMS = "iphoneos iphonesimulator macosx";')
        o('\t\t\t\tSUPPORTS_MACCATALYST = NO;')
        o('\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";')
        o('\t\t\t\tENABLE_HARDENED_RUNTIME = YES;')
    else:
        o('\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO; CLANG_ENABLE_MODULES = YES;')
        o('\t\t\t\tCOPY_PHASE_STRIP = NO; ENABLE_STRICT_OBJC_MSGSEND = YES;')
        o('\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;')
        o('\t\t\t\tMACOSX_DEPLOYMENT_TARGET = 14.0;')
        o('\t\t\t\tSDKROOT = auto;')
        if name == "Debug":
            o('\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf; MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;')
            o('\t\t\t\tONLY_ACTIVE_ARCH = YES; SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG; SWIFT_OPTIMIZATION_LEVEL = "-Onone";')
        else:
            o('\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym"; SWIFT_COMPILATION_MODE = wholemodule; VALIDATE_PRODUCT = YES;')
    o(f'\t\t\t}}; name = {name}; }};')

write_config(ids["debug_proj"], "Debug")
write_config(ids["release_proj"], "Release")
write_config(ids["debug_tgt"], "Debug", True)
write_config(ids["release_tgt"], "Release", True)

o("/* End XCBuildConfiguration section */")
o("")
o("/* Begin XCConfigurationList section */")
o(f'\t\t{ids["proj_configs"]} = {{isa = XCConfigurationList; buildConfigurations = ({ids["debug_proj"]} /* Debug */, {ids["release_proj"]} /* Release */); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};')
o(f'\t\t{ids["tgt_configs"]} = {{isa = XCConfigurationList; buildConfigurations = ({ids["debug_tgt"]} /* Debug */, {ids["release_tgt"]} /* Release */); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; }};')
o("/* End XCConfigurationList section */")
o("\t};")
o(f'\trootObject = {ids["project"]} /* Project object */;')
o("}")

(ROOT / "ScienceBowlCoach.xcodeproj" / "project.pbxproj").write_text("\n".join(lines))
print(f"Generated project with {len(file_map)} Swift files and {len(resource_map)} JSON resources")
