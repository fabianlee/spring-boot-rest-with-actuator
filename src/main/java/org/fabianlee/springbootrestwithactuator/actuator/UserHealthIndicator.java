package org.fabianlee.springbootrestwithactuator.actuator;

import org.fabianlee.springbootrestwithactuator.user.UserController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.health.contributor.Health;
import org.springframework.boot.health.contributor.HealthIndicator;
import org.springframework.stereotype.Component;

@Component
public class UserHealthIndicator implements HealthIndicator {
    
    @Autowired
    protected UserController userController;

    @Override
    public Health health() {
        int userCount = userController.fetchUserCount().get().intValue();
        if (userCount>0) 
            return new Health.Builder().up().withDetail("usercount", userCount).build();
        else
            return new Health.Builder().down().withDetail("usercount", userCount).build();
    }

}