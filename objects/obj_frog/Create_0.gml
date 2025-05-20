// Create
state = "Idle"; // Initial state
current_body_sprite = spr_frog_idle_body;
current_head_sprite = spr_frog_idle_head;
image_speed = 1; // Animation speed for idle and pre-hop animations

// Jump charge variables
jump_charge = 0;
jump_charge_max = 100; // Maximum charge value
charge_rate = 2;       // Charge increase per step

// Movement and gravity variables
vsp = 0; // Vertical speed
hsp = 0; // Horizontal speed
gravity_val = 0.5; // Gravity strength

// Jumping and Direction
facing = 1; // 1 for right, -1 for left
base_jump_power_vertical = 7;   // Max vertical power
base_jump_power_horizontal = 1; // Horizontal speed when jumping with direction
air_control_force = 0.3;        // How much keys affect hsp in air
max_hsp_air = 3;                // Max horizontal speed from air control input

// Attack variables
arrow_angle = 90;      // Start at the top (90° = straight up in GameMaker)
arrow_speed = 2;       // Speed of arrow oscillation (degrees per step)
arrow_direction = 1;   // 1 = clockwise, -1 = counterclockwise
arrow_min_angle = 30;  // Minimum angle (30° = top-right)
arrow_max_angle = 150; // Maximum angle (150° = top-left)
arrow_distance = 24;   // Distance of arrow from frog's center
can_attack = true;     // Whether player can attack

// Tongue variables
tongue_active = false;    // Whether the tongue is currently out
tongue_angle = 0;         // Angle of tongue extension
tongue_length = 0;        // Current tongue length
tongue_max_length = 64;   // Maximum tongue extension length
tongue_speed = 4;         // Speed of tongue extension
tongue_retracting = false; // Whether tongue is extending (false) or retracting (true)
tongue_damage = 10;       // Damage dealt by tongue hit
