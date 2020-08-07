classdef Version
    %Version
    %   BSP Version information
    properties(Constant)
        MATLAB = 'R2020a';
        Release = '20.1.1';
    end
    properties(Dependent)
        VivadoShort
    end
    
    methods
        function value = get.VivadoShort(obj)
            value = obj.Vivado(1:6); 
        end
    end
end

