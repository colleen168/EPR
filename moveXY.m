function res = moveXY(ac, ak, xd, yd, vx, vy)
    if ~ak.inWorkspace(xd, yd)
        res = -1;
        display('E-Kin: not in workspace');
        return;
    end
    curTh1 = ac.theta1;
    curTh2 = ac.theta2;
    curTilt = ac.phi;
    [th1, th2, tilt, res] = ak.findThetas(xd,yd);
    if res < 0
        display('E-Kin: cant proceed with straight movement');
        return;
    end
    res = ak.getJointVelocities(curTh1, curTh2, vx, vy);
    w1 = abs(res(1));
    w2 = abs(res(2));
    acNew = ArmConfiguration(th1, th2, 0);
    acNew.w1 = w1;
    acNew.w2 = w2;
    res = Dynamixels.setArmConfig(acNew);
    if res < 0
        Display('E-Dyn: arm config setup failed');
        return;
    end
end


