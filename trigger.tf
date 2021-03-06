## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_trigger" "test_trigger" {
    defined_tags   = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release}
    display_name   = "${var.app_name}_${random_string.deploy_id.result}_trigger_from_ocir"
    freeform_tags  = {}
    project_id     = oci_devops_project.test_project.id
    repository_id  = oci_devops_repository.test_repository.id
    trigger_source = var.trigger_trigger_source
    depends_on = [oci_devops_build_pipeline_stage.test_build_pipeline_stage,
    oci_devops_build_pipeline_stage.test_deliver_artifact_stage,
    oci_devops_build_pipeline_stage.test_deliver_artifact_stage2,
    oci_devops_build_pipeline_stage.test_deploy_stage,
    oci_devops_deploy_pipeline.test_deploy_pipeline,
    oci_devops_build_run.test_build_run_1
    ]

    actions {
        build_pipeline_id = oci_devops_build_pipeline.test_build_pipeline.id
        type              = var.trigger_action_to_invoke

        filter {
            events         = [
                var.trigger_trigger_input_event_type,
            ]
            trigger_source = var.trigger_trigger_source

            include {
                head_ref = var.trigger_source_repo_branch
            }
        }
    }

    timeouts {}
}