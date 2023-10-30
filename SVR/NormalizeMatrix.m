function output1  = NormalizeMatrix(input1, option)
    %{
    option 0 corresponds to dividing the signal with norm
    option 1 corresponds to dividing the signal with variance
    %}

    % subtracting mean
    var00 = input1 - mean(input1,1);

    % dividing by 
    if option == 0
        var00 = var00./vecnorm(var00, 1);
    elseif option == 1
        var00 = var00./var(var00);
    else
        fprintf("Error, invalid option");
    end

    output1 = var00;
end
