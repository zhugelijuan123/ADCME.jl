using PyCall


if Sys.iswindows()
    @warn "PyTorch plugin is still under construction for Windows platform. Make sure tensorflow==1.14 is installed properly on your platform."
end

function install_tensorflow()
    run(`$(PyCall.python) -m pip install tensorflow==1.14`)
end

try
    tf = pyimport("tensorflow")
    if !(tf.VERSION=="1.14.0")
        println("Current tensorflow version = $(tf.VERSION)")
        install_tensorflow()
    end
    # See if it works already
catch ee
    install_tensorflow()
    pyimport("tensorflow")
end


# Install Eigen3 library
if !isdir("$(@__DIR__)/Libraries")
    mkdir("$(@__DIR__)/Libraries")
end

if !isfile("$(@__DIR__)/Libraries/eigen.zip")
    download("http://bitbucket.org/eigen/eigen/get/3.3.7.zip","$(@__DIR__)/Libraries/eigen.zip")
end

if !isdir("$(@__DIR__)/Libraries/eigen3")    
    run(`unzip $(@__DIR__)/Libraries/eigen.zip`)
    run(`mv $(@__DIR__)/eigen-eigen-323c052e1731 $(@__DIR__)/Libraries/eigen3`)
end

# Install Torch library
if Sys.isapple()
    if !isfile("$(@__DIR__)/Libraries/libtorch.zip")
        download("https://download.pytorch.org/libtorch/cpu/libtorch-macos-latest.zip","$(@__DIR__)/Libraries/libtorch.zip")
    end
    if !isdir("$(@__DIR__)/Libraries/libtorch")
        run(`unzip $(@__DIR__)/Libraries/libtorch.zip`)
        run(`mv $(@__DIR__)/libtorch $(@__DIR__)/Libraries/libtorch`)
        download("https://github.com/intel/mkl-dnn/releases/download/v0.19/mklml_mac_2019.0.5.20190502.tgz","$(@__DIR__)/Libraries/mklml_mac_2019.0.5.20190502.tgz")
        run(`tar -xvzf $(@__DIR__)/Libraries/mklml_mac_2019.0.5.20190502.tgz`)
        run(`mv $(@__DIR__)/mklml_mac_2019.0.5.20190502/lib/libiomp5.dylib $(@__DIR__)/Libraries/libtorch/lib/`)
        run(`mv $(@__DIR__)/mklml_mac_2019.0.5.20190502/lib/libmklml.dylib $(@__DIR__)/Libraries/libtorch/lib/`)
        run(`rm -rf $(@__DIR__)/mklml_mac_2019.0.5.20190502/`)
    end
elseif Sys.islinux()
    if !isfile("$(@__DIR__)/Libraries/libtorch.zip")
        download("https://download.pytorch.org/libtorch/cpu/libtorch-shared-with-deps-latest.zip","$(@__DIR__)/Libraries/libtorch.zip")
    end
    if !isdir("$(@__DIR__)/Libraries/libtorch")
        run(`unzip $(@__DIR__)/Libraries/libtorch.zip`)
        run(`mv $(@__DIR__)/libtorch $(@__DIR__)/Libraries/libtorch`)
        download("https://github.com/intel/mkl-dnn/releases/download/v0.19/mklml_lnx_2019.0.5.20190502.tgz","$(@__DIR__)/Libraries/mklml_lnx_2019.0.5.20190502.tgz")
        run(`tar -xvzf $(@__DIR__)/Libraries/mklml_lnx_2019.0.5.20190502.tgz`)
        run(`mv $(@__DIR__)/mklml_lnx_2019.0.5.20190502/lib/libiomp5.so $(@__DIR__)/Libraries/libtorch/lib/`)
        run(`mv $(@__DIR__)/mklml_lnx_2019.0.5.20190502/lib/libmklml_gnu.so $(@__DIR__)/Libraries/libtorch/lib/`)
        run(`mv $(@__DIR__)/mklml_lnx_2019.0.5.20190502/lib/libmklml_intel.so $(@__DIR__)/Libraries/libtorch/lib/`)
        run(`rm -rf $(@__DIR__)/mklml_lnx_2019.0.5.20190502/`)
    end
end
