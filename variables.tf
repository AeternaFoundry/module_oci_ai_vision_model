variable "ai_vision_models" {
  description = <<EOT
Map of ai_vision_models, attributes below
Required:
    - compartment_id
    - model_type
    - project_id
    - training_dataset (block):
        - bucket (optional)
        - dataset_id (optional)
        - dataset_type (required)
        - namespace_name (optional)
        - object (optional)
Optional:
    - defined_tags
    - description
    - display_name
    - freeform_tags
    - is_quick_mode
    - max_training_duration_in_hours
    - model_version
    - testing_dataset (block):
        - bucket (optional)
        - dataset_id (optional)
        - dataset_type (required)
        - namespace_name (optional)
        - object (optional)
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
    - validation_dataset (block):
        - bucket (optional)
        - dataset_id (optional)
        - dataset_type (required)
        - namespace_name (optional)
        - object (optional)
EOT

  type = map(object({
    compartment_id                 = string
    model_type                     = string
    project_id                     = string
    defined_tags                   = optional(map(string))
    description                    = optional(string)
    display_name                   = optional(string)
    freeform_tags                  = optional(map(string))
    is_quick_mode                  = optional(bool)
    max_training_duration_in_hours = optional(number)
    model_version                  = optional(string)
    training_dataset = object({
      bucket         = optional(string)
      dataset_id     = optional(string)
      dataset_type   = string
      namespace_name = optional(string)
      object         = optional(string)
    })
    testing_dataset = optional(object({
      bucket         = optional(string)
      dataset_id     = optional(string)
      dataset_type   = string
      namespace_name = optional(string)
      object         = optional(string)
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
    validation_dataset = optional(object({
      bucket         = optional(string)
      dataset_id     = optional(string)
      dataset_type   = string
      namespace_name = optional(string)
      object         = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.ai_vision_models : (
        contains([for v in ["DATA_SCIENCE_LABELING", "OBJECT_STORAGE"] : lower(v)], lower(v.training_dataset.dataset_type))
      )
    ])
    error_message = "must be one of: \"DATA_SCIENCE_LABELING\", \"OBJECT_STORAGE\""
  }
  validation {
    condition = alltrue([
      for k, v in var.ai_vision_models : (
        v.testing_dataset == null || (contains([for v in ["DATA_SCIENCE_LABELING", "OBJECT_STORAGE"] : lower(v)], lower(v.testing_dataset.dataset_type)))
      )
    ])
    error_message = "must be one of: \"DATA_SCIENCE_LABELING\", \"OBJECT_STORAGE\""
  }
  validation {
    condition = alltrue([
      for k, v in var.ai_vision_models : (
        v.validation_dataset == null || (contains([for v in ["DATA_SCIENCE_LABELING", "OBJECT_STORAGE"] : lower(v)], lower(v.validation_dataset.dataset_type)))
      )
    ])
    error_message = "must be one of: \"DATA_SCIENCE_LABELING\", \"OBJECT_STORAGE\""
  }
}

