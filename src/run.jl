import Base:run

export
run,
Session,
global_variables_initializer,
init

function Session(args...;kwargs...)
    config = tf.ConfigProto()
    config.gpu_options.allow_growth=true
    tf.Session(args...;config=config, kwargs...)
end

function Base.:run(o::PyObject, fetches::Union{Nothing, PyObject, Array, Tuple}=nothing, args...; kwargs...)
    o.run(fetches, args...; kwargs...)
end

function global_variables_initializer()
    tf.global_variables_initializer()
end

function init(o::PyObject)
    run(o, global_variables_initializer())
end