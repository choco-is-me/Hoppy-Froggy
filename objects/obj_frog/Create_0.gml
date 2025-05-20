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
