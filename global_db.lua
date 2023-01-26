local global_map = {
    client_list = {
        "Shorty",
        "Mr",
        "Prozer",
        "Lord",
        "Test",
        "Creunix",
        "Blyatman",
        "Yolo"
    },

    rf_limits = {
        Shorty={11000},
        Mr={2200},
        Prozer={3300},
        Lord={4400},
        Test={123456789000},
        Creunix={99000},
        Blyatman={123456},
        Yolo={32154}
    },

    energy_detector_number = {
        Shorty={1},
        Mr={8},
        Prozer={3},
        Lord={5},
        Test={7},
        Creunix={4},
        Blyatman={2},
        Yolo={0}
    },

    pc_id = {
        Shorty={0},
        Mr={1},
        Prozer={2},
        Lord={3},
        Test={4},
        Creunix={5,6,7,8,9},
        Blyatman={10},
        Yolo={11}
    },

    pc_id_function = {
        shop={0,1,2,3,5,6,7,8,9,10,11},
        edf={4}
    },

    client_display_color = {
        Shorty=colors.gray,
        Mr=colors.blue,
        Prozer=colors.red,
        Lord=colors.orange,
        Test=colors.yellow,
        Creunix=colors.lightBlue,
        Blyatman=colors.pink,
        Yolo=colors.brown
    }
}
return global_map