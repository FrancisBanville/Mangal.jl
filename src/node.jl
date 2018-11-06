function nodes()
    results = search_objects_by_query(
        Mangal.api_endpoints.node,
        nothing,
        Mangal.format_node_response
    )
    Mangal.cache(results)
    return results
end

function nodes(q::Vector{Pair{String,T}}) where {T <: Any}
    results = search_objects_by_query(
        Mangal.api_endpoints.node,
        q,
        Mangal.format_node_response
    )
    Mangal.cache(results)
    return results
end

function nodes(network::MangalNetwork)
    query = [Pair("network_id", network.id)]
    return nodes(query)
end

function nodes(network::MangalNetwork, query::Vector{Pair{String,T}}) where {T <: Any}
    push!(query, Pair("network_id", network.id))
    return nodes(query)
end

"""
    nodes(taxon::MangalReferenceTaxon)

Returns the nodes that are instance of a `MangalReferenceTaxon`.
"""
function nodes(taxon::MangalReferenceTaxon)
    query = [Pair("taxo_id", taxon.id)]
    return nodes(query)
end

"""
    nodes(taxon::MangalReferenceTaxon, query::Vector{Pair{String,T}}) where {T <: Any}

Returns the nodes that are instance of a `MangalReferenceTaxon`, with an additional query.
"""
function nodes(taxon::MangalReferenceTaxon, query::Vector{Pair{String,T}}) where {T <: Any}
    push!(query, Pair("taxo_id", taxon.id))
    return nodes(query)
end

""""
    node(id::Int64)

Returns a node object by id.
"""
function node(id::Int64)
    return get(_MANGAL_CACHES[MangalNode], id, first(nodes([Pair("id", id)])))
end