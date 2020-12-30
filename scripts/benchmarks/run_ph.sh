#!/bin/sh
julia -e 'include("ph_scaling/ph_1.jl")'
julia -e 'include("ph_scaling/ph_2.jl")'
julia -e 'include("ph_scaling/ph_4.jl")'
julia -e 'include("ph_scaling/ph_8.jl")'
julia -e 'include("ph_scaling/ph_16.jl")'
julia -e 'include("ph_scaling/ph_32.jl")'
