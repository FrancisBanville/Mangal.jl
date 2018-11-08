
````julia
using Mustache
using Dates

tpl = mt"""
## General informations

**Dataset**: {{name}} [`{{id}}`]

**Sampling date**: {{date}}

**Added on**: {{created}} (last update on {{updated}})

**Number of networks**: {{ncount}}

## Description

{{description}}

## Programmatic access

    using Mangal
    {{rawname}} = dataset("{{rawname}}") # or dataset({{id}})

## Networks

{{networks}}

"""

for d in datasets(["sort" => "id"])
   _clean_name = titlecase(replace(d.name, "_" => " "))
   ncount = count(MangalNetwork, ["dataset_id" => d.id])
   page_size = 200
   n_pages = convert(Int64, ceil(ncount/page_size))
   n = MangalNetwork[]
   for p in 1:n_pages
      paging_q = ["count" => page_size, "page" => p-1]
      q = ["dataset_id" => d.id]
      append!(q, paging_q)
      append!(n, networks(d, q))
   end
   rows = String[]
   push!(rows, "| id | name | description | public | nodes |\n")
   push!(rows, "|:--:|------|-------------|--------|-------|\n")
   for ne in n
      nnode = count(MangalNode, ["network_id" => ne.id])
      pub = ne.public ? "✓" : ""
      push!(rows, "| `$(ne.id)` | `$(ne.name)` | $(ne.description) | $(pub) | $(nnode) |\n")
   end
   _infos = Dict(
      "name" => _clean_name,
      "rawname" => d.name,
      "description" => d.description,
      "id" => d.id,
      "date" => Dates.format(d.date, "yyyy-mm-dd"),
      "created" => Dates.format(d.created, "yyyy-mm-dd"),
      "updated" => Dates.format(d.updated, "yyyy-mm-dd"),
      "ncount" => ncount,
      "networks" => reduce(*, rows)
      )
   _text = render(tpl, _infos)
   write(joinpath("docs", "src", "data", "dataset", "$(d.name).md"), _text)
end
````

