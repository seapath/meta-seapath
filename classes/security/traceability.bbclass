# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Generate traceability matrix artifacts.
#
# It will iterate over documents declared in TRACEABILITY_DOCUMENTS to fetch
# information from TRACEABILITY_<documentname>
#
# Variable flags must be used to store requirement-to-test traceability.
#
# For example:
#    # Two documents to trace : doc1 doc2
#    TRACEABILITY_DOCUMENTS = "doc1 doc2"
#
#    # The following variable should then be used to declare requirement-to-test
#    TRACEABILITY_DOC1[REQ1] = "category:TESTID-0001"
#    TRACEABILITY_DOC2[REQ3] = "category:TESTID-0001 category:TESTID-0002"
#
# Lookup of test identifiers and description depends on the declared "category"
# which represent the test method.
# If a category isn't supported, the test case will be stored in "unknown"
#
# Any requirement not covered will be highlighted in a dedicated section
# in the documentation.
#
# Finally, the format can be specified using TRACEABILITY_DOC_FORMAT to generate
# the artifact in TRACEABILITY_OUTPUT_DIR
#

TRACEABILITY_DOCUMENTS ?= ""
TRACEABILITY_DOCUMENTS[doc] = "Space-separated list of documents for which a traceability matrix should be generated. The document name should then be used to declare a variable TRACEABILITY_<docname>"

TRACEABILITY_DOC_FORMAT ?= "asciidoc"
TRACEABILITY_DOC_FORMAT[doc] = "Specify the output format for the traceability matrix artifacts"

TRACEABILITY_OUTPUT_DIR ?= "${SEC_ROOTDIR}"
TRACEABILITY_DOC_FORMAT[doc] = "Specify the output directory for the artifacts."

TRACEABILITY_CUKINIA_TESTS_DIR ?= "${CUKINIA_TESTS_DIR}"
TRACEABILITY_CUKINIA_TESTS_DIR[doc] = "Specify the directory in which Cukinia method should lookup."

TRACEABILITY_SUPPORTED_CATEGORIES = "cukinia yocto"
TRACEABILITY_SUPPORTED_CATEGORIES[doc] = "Space-separated list of supported categories. Used for selecting test lookup method."

def handle_traceability_cukinia(testid, d):
    import subprocess

    cukinia_tests_path = d.getVar("TRACEABILITY_CUKINIA_TESTS_DIR", True)
    description = "Unknown description"
    status = "missing"
    if not os.path.exists(cukinia_tests_path):
        bb.warn("Path '%s' for accessing cukinia tests not found. Indicated as 'missing'.")
    else:
        try:
            output = subprocess.run(["grep", "-RhoP", "as \"%s - \K([^\"]+)" % testid, cukinia_tests_path], capture_output=True, check=True)
            description = output.stdout.decode('utf-8')
            status = "check test results"
        except Exception as e:
            bb.warn("Error while looking up for Cukinia test with id '%s'. Indicated as 'missing'." % testid)
            description = "Not found in test corpus"
            status = "missing"
    return description, status

def handle_traceability_yocto(testid, d):
    return d.getVarFlag(testid, "traceability") or "Unknown description", "check build artifacts"

def handle_traceability_unknown(testid, d):
    return "Unknown test identifier : %s" % testid, "unknown"

def generate_document_asciidoc(doc_path, doc_name, traceability_dict, supported_categories):
    with open(doc_path, "w") as traceability_doc:
        traceability_doc.write("= Tracability matrix : %s\n" % doc_name.upper())
        traceability_doc.write("\n== Tests to requirements matrix\n")
        traceability_doc.write("The following table list the tests with declared requirements covering.\n")
        traceability_doc.write("Tests are extracted from the following categories:\n\n")
        traceability_doc.write("\n".join(["* %s" % x for x in supported_categories]))
        traceability_doc.write("\n\n|=== \n")
        traceability_doc.write("| Test identifier / function | Requirements | Description | Status\n\n")
        for testid in traceability_dict.keys():
            if testid != "uncovered":
                traceability_doc.write("|%s\n|%s\n|%s\n|%s\n\n" % (testid , ", ".join(traceability_dict[testid]["requirements"]), traceability_dict[testid]["description"], traceability_dict[testid]["status"]))
        traceability_doc.write("\n|===\n")
        traceability_doc.write("\n== Uncovered requirements\n")
        traceability_doc.write("The following requirements are not covered by any test:\n")
        traceability_doc.write("%s" % ", ".join(traceability_dict["uncovered"]["requirements"]))

python generate_traceability_document() {
    outdir = d.getVar("TRACEABILITY_OUTPUT_DIR")
    supported_documents = d.getVar("TRACEABILITY_DOCUMENTS", True).split() or []
    supported_categories = d.getVar("TRACEABILITY_SUPPORTED_CATEGORIES", True).split() or []
    docformat = d.getVar("TRACEABILITY_DOC_FORMAT") or "None"
    imagename = d.getVar("IMAGE_BASENAME") or "unknown-image"

    for doc in supported_documents:
        traceability_dict = {}
        traceability_var = "TRACEABILITY_" + doc.upper()
        requirements_list = d.getVarFlags(traceability_var) or {}
        traceability_dict["uncovered"] = { "category" : "unknown",
                                          "requirements" : [],
                                          "description" : "This requirement is not covered",
                                          "status" : "not covered"}
        if requirements_list:
            for req in requirements_list.keys():
                tests_list = requirements_list[req]
                if tests_list:
                    for list in [ x.split(":") for x in tests_list.split() ]:
                        category=list[0] if len(list) == 2 else "unknown"
                        testid=list[1] if len(list) == 2 else list[0]

                        if testid not in traceability_dict.keys():
                            traceability_dict[testid] = { "category" : category,
                                                         "requirements" : [req],
                                                         "description" : "",
                                                         "status" : ""}
                        else:
                            traceability_dict[testid]["requirements"].append(req)

                        if category not in supported_categories:
                            bb.warn("Entry '%s' is using an unsupported category '%s'. Will be treated as 'unknown'" % (traceability_dict[testid], testid))
                            category = "unknown"

                        try:
                            locs = { "testid" : testid, "d" : d }
                            testdesc, status = bb.utils.better_eval("handle_traceability_" + category + "(testid, d)", locs)
                            traceability_dict[testid]["description"] = testdesc
                            traceability_dict[testid]["status"] = status
                        except:
                            bb.error("Error while executing function : handle_traceability_%s for entry '%s' !" % (category, testid))
                else:
                    traceability_dict["uncovered"]["requirements"].append(req)
            try:
                locs = {
                    "doc_path" : os.path.join(outdir, "traceability-matrix_%s_%s.adoc" % (imagename, doc)),
                    "doc_name" : doc,
                    "traceability_dict" : traceability_dict,
                    "supported_categories" : supported_categories
                }
                bb.utils.better_eval("generate_document_" + docformat + "(doc_path, doc_name, traceability_dict, supported_categories)", locs)
            except:
                bb.error("Unsupported format: %s" % docformat)
        else:
            bb.warn("No traceability to document '%s' found for image '%s'. Skipped" % (doc, d.getVar("IMAGE_BASENAME")))
}

IMAGE_POSTPROCESS_COMMAND += "generate_traceability_document;"
