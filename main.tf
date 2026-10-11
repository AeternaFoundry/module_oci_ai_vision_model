resource "oci_ai_vision_model" "ai_vision_models" {
  for_each = var.ai_vision_models

  compartment_id                 = each.value.compartment_id
  model_type                     = each.value.model_type
  project_id                     = each.value.project_id
  defined_tags                   = each.value.defined_tags
  description                    = each.value.description
  display_name                   = each.value.display_name
  freeform_tags                  = each.value.freeform_tags
  is_quick_mode                  = each.value.is_quick_mode
  max_training_duration_in_hours = each.value.max_training_duration_in_hours
  model_version                  = each.value.model_version

  training_dataset {
    bucket         = each.value.training_dataset.bucket
    dataset_id     = each.value.training_dataset.dataset_id
    dataset_type   = each.value.training_dataset.dataset_type
    namespace_name = each.value.training_dataset.namespace_name
    object         = each.value.training_dataset.object
  }

  dynamic "testing_dataset" {
    for_each = each.value.testing_dataset != null ? [each.value.testing_dataset] : []
    content {
      bucket         = testing_dataset.value.bucket
      dataset_id     = testing_dataset.value.dataset_id
      dataset_type   = testing_dataset.value.dataset_type
      namespace_name = testing_dataset.value.namespace_name
      object         = testing_dataset.value.object
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }

  dynamic "validation_dataset" {
    for_each = each.value.validation_dataset != null ? [each.value.validation_dataset] : []
    content {
      bucket         = validation_dataset.value.bucket
      dataset_id     = validation_dataset.value.dataset_id
      dataset_type   = validation_dataset.value.dataset_type
      namespace_name = validation_dataset.value.namespace_name
      object         = validation_dataset.value.object
    }
  }
}

