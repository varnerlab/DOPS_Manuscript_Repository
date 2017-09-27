function stop= myoutput(x,optimvalues,state )
    stop = false;
    if isequal(state,'iter')
          history = [history; x];
    end
end
    

