macro forward(ex, fs)
  Meta.isexpr(ex, :., 2) || error("Invalid expression $ex, expected <Type>.<prop>")
  T, prop = ex.args
  isa(prop, QuoteNode) && (prop = prop.value)

  fs = Meta.isexpr(fs, :tuple) ? fs.args : [fs]

  defs = map(fs) do f
    esc(:($f(x::$T, args...; kwargs...) = $f(x.$prop, args...; kwargs...)))
  end

  Expr(:block, defs...)
end
