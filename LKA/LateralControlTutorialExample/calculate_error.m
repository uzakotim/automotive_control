function err = calculate_error(yaw, ref_yaw, prev_err)
    error = ref_yaw - yaw;
    aux_err = [error, error - 2 * pi, error + 2 * pi];
    abs_aux_err = abs(aux_err);
    [min_abs_err, min_i] = min(abs_aux_err);
    error = aux_err(min_i);

    if(abs(error) < 10.0 * (pi/12))
        if(abs(prev_err - error) > pi/2)
            error = error - sign(error) * 2 * pi;
        end
    end
       err = error;