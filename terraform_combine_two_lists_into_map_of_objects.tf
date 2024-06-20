locals {
  parent_list = [
    "item_1",
    "item_2",
    "item_n"
  ]
  child_list = [
    "subitem_1",
    "subitem_2",
    "subitem_3",
    "subitem_n",
  ]
  combined_map = { for i in flatten([
    for x in local.parent_list : [
      for y in local.child_list : {
        name         = "${x}-${y}"
        developer    = x
        subscription = y
      }
    ]
  ]) : i.name => i }
}

output "combined_lists_object" {
  description = "The two lists combined into a map of objects with values from both and unique keys."
  value = local.combined_map
}