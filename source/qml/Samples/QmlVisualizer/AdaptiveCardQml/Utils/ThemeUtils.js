.pragma library

function getColorSet(colorSet, state, isDarkTheme) {
    var colors = isDarkTheme ? colorsDark[colorSet][state] : colorsLight[colorSet][state]
    return Qt.rgba(colors.r / 256, colors.g / 256, colors.b / 256, colors.a);
}

var colorsLight = {
    "card-disabled-border": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.2
        }
    },
    "textinput-border": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.5
        },
        "focused": {
            "r": 17,
            "g": 112,
            "b": 207,
            "a": 1
        }
    },
    "text-highlight": {
        "normal": {
            "r": 199,
            "g": 246,
            "b": 255,
            "a": 1
        }
    },
    "textinput-background": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 1
        },
        "pressed": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.3
        },
        "hovered": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.07
        }
    },
    "textinput-error-background": {
        "normal": {
            "r": 255,
            "g": 232,
            "b": 234,
            "a": 1
        }
    },
    "textinput-error-border": {
        "normal": {
            "r": 171,
            "g": 10,
            "b": 21,
            "a": 1
        },
        "focused": {
            "r": 171,
            "g": 10,
            "b": 21,
            "a": 1
        }
    },
    "textinput-placeholder-text": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.7
        }
    },
    "textinput-text": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        }
    },
    "label-error-text": {
        "normal": {
            "r": 171,
            "g": 10,
            "b": 21,
            "a": 1
        }
    },
    "checkbox-checked-icon": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        }
    },
    "checkbox-checked-border": {
        "normal": {
            "r": 17,
            "g": 112,
            "b": 207,
            "a": 1
        },
        "hovered": {
            "r": 3,
            "g": 83,
            "b": 168,
            "a": 1
        },
        "pressed": {
            "r": 6,
            "g": 58,
            "b": 117,
            "a": 1
        }
    },
    "checkbox-checked-background": {
        "normal": {
            "r": 17,
            "g": 112,
            "b": 207,
            "a": 1
        },
        "hovered": {
            "r": 3,
            "g": 83,
            "b": 168,
            "a": 1
        },
        "pressed": {
            "r": 6,
            "g": 58,
            "b": 117,
            "a": 1
        }
    },
    "checkbox-unchecked-background": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.2
        },
        "hovered": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.3
        },
        "pressed": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.4
        }
    },
    "button-primary-background": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        },
        "hovered": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.8
        },
        "pressed": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.7
        }
    },
    "button-primary-border": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        },
        "hovered": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        },
        "pressed": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        }
    },
    "button-primary-text": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        }
    },
    "button-secondary-background": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0
        },
        "hovered": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.07
        },
        "pressed": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.2
        }
    },
    "button-secondary-text": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        },
        "hovered": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        },
        "pressed": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        },
        "disabled": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.4
        }
    },
    "button-secondary-border": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.3
        },
        "hovered": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.3
        },
        "pressed": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.3
        }
    },
    "button-join-outline-background": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0
        },
        "hovered": {
            "r": 24,
            "g": 94,
            "b": 70,
            "a": 1
        },
        "pressed": {
            "r": 19,
            "g": 66,
            "b": 49,
            "a": 1
        }
    },
    "button-join-outline-border": {
        "normal": {
            "r": 24,
            "g": 94,
            "b": 70,
            "a": 1
        },
        "hovered": {
            "r": 24,
            "g": 94,
            "b": 70,
            "a": 1
        },
        "pressed": {
            "r": 19,
            "g": 66,
            "b": 49,
            "a": 1
        }
    },
    "button-join-outline-text": {
        "normal": {
            "r": 24,
            "g": 94,
            "b": 70,
            "a": 1
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        }
    },
    "button-cancel-outline-background": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0
        },
        "hovered": {
            "r": 171,
            "g": 10,
            "b": 21,
            "a": 1
        },
        "pressed": {
            "r": 120,
            "g": 13,
            "b": 19,
            "a": 1
        }
    },
    "button-cancel-outline-border": {
        "normal": {
            "r": 171,
            "g": 10,
            "b": 21,
            "a": 1
        },
        "hovered": {
            "r": 171,
            "g": 10,
            "b": 21,
            "a": 1
        },
        "pressed": {
            "r": 120,
            "g": 13,
            "b": 19,
            "a": 1
        }
    },
    "button-cancel-outline-text": {
        "normal": {
            "r": 171,
            "g": 10,
            "b": 21,
            "a": 1
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        }
    }
}

var colorsDark = {
    "card-disabled-border": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.2
        }
    },
    "textinput-border": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.5
        },
        "focused": {
            "r": 100,
            "g": 180,
            "b": 250,
            "a": 1
        }
    },
    "text-highlight": {
        "normal": {
            "r": 9,
            "g": 45,
            "b": 59,
            "a": 1
        }
    },
    "textinput-background": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 1
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.3
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.07
        }
    },
    "textinput-error-background": {
        "normal": {
            "r": 79,
            "g": 14,
            "b": 16,
            "a": 1
        }
    },
    "textinput-error-border": {
        "normal": {
            "r": 252,
            "g": 139,
            "b": 152,
            "a": 1
        },
        "focused": {
            "r": 252,
            "g": 139,
            "b": 152,
            "a": 1
        }
    },
    "textinput-placeholder-text": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.7
        }
    },
    "textinput-text": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
    },
    "label-error-text": {
        "normal": {
            "r": 252,
            "g": 139,
            "b": 152,
            "a": 1
        }
    },
    "checkbox-checked-icon": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        }
    },
    "checkbox-checked-border": {
        "normal": {
            "r": 100,
            "g": 180,
            "b": 250,
            "a": 1
        },
        "hovered": {
            "r": 52,
            "g": 146,
            "b": 235,
            "a": 1
        },
        "pressed": {
            "r": 17,
            "g": 112,
            "b": 207,
            "a": 1
        }
    },
    "checkbox-checked-background": {
        "normal": {
            "r": 100,
            "g": 180,
            "b": 250,
            "a": 1
        },
        "hovered": {
            "r": 52,
            "g": 146,
            "b": 235,
            "a": 1
        },
        "pressed": {
            "r": 17,
            "g": 112,
            "b": 207,
            "a": 1
        }
    },
    "checkbox-unchecked-background": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.2
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.3
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.4
        }
    },
    "button-primary-background": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.8
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.7
        }
    },
    "button-primary-border": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        }
    },
    "button-primary-text": {
        "normal": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        },
        "hovered": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        },
        "pressed": {
            "r": 0,
            "g": 0,
            "b": 0,
            "a": 0.95
        }
    },
    "button-secondary-background": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.07
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.2
        }
    },
    "button-secondary-text": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "disabled": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.4
        }
    },
    "button-secondary-border": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.3
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.3
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.3
        }
    },
    "button-join-outline-background": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0
        },
        "hovered": {
            "r": 24,
            "g": 94,
            "b": 70,
            "a": 1
        },
        "pressed": {
            "r": 19,
            "g": 66,
            "b": 49,
            "a": 1
        }
    },
    "button-join-outline-border": {
        "normal": {
            "r": 60,
            "g": 194,
            "b": 154,
            "a": 1
        },
        "hovered": {
            "r": 24,
            "g": 94,
            "b": 70,
            "a": 1
        },
        "pressed": {
            "r": 19,
            "g": 66,
            "b": 49,
            "a": 1
        }
    },
    "button-join-outline-text": {
        "normal": {
            "r": 60,
            "g": 194,
            "b": 154,
            "a": 1
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        }
    },
    "button-cancel-outline-background": {
        "normal": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0
        },
        "hovered": {
            "r": 171,
            "g": 10,
            "b": 21,
            "a": 1
        },
        "pressed": {
            "r": 120,
            "g": 13,
            "b": 19,
            "a": 1
        }
    },
    "button-cancel-outline-border": {
        "normal": {
            "r": 252,
            "g": 139,
            "b": 152,
            "a": 1
        },
        "hovered": {
            "r": 171,
            "g": 10,
            "b": 21,
            "a": 1
        },
        "pressed": {
            "r": 120,
            "g": 13,
            "b": 19,
            "a": 1
        }
    },
    "button-cancel-outline-text": {
        "normal": {
            "r": 252,
            "g": 139,
            "b": 152,
            "a": 1
        },
        "hovered": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        },
        "pressed": {
            "r": 255,
            "g": 255,
            "b": 255,
            "a": 0.95
        }
    }
}
