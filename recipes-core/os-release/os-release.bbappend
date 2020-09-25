OS_RELEASE_FIELDS += "GITVERSION_BRANCHVERSION"
GITVERSION_BRANCHVERSION = "${GitVersion_BranchVersion}"

do_compile[nostamp] = "1"
do_install[nostamp] = "1"
