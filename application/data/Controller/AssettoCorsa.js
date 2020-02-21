module.exports = {
    mode: 'AssettoCorsa',
    custom: {
        offset: 5,
        sensitivity: 0.1
    },
    layout: [
        0x003, 0x003, 0x000, 0x000, 0x000,
        0x003, 0x003, 0x000, 0x000, 0x000,
        0x003, 0x003, 0x000, 0x000, 0x000,
        0x003, 0x003, 0x000, 0x000, 0x000,
        0x003, 0x003, 0x000, 0x000, 0x000,
        0x002, 0x002, 0x002, 0x002, 0xFFF,
        0x004, 0x004, 0x001, 0x001, 0x001,
        0x004, 0x004, 0x001, 0x001, 0x001,
        0x004, 0x004, 0x001, 0x001, 0x001,
        0x004, 0x004, 0x001, 0x001, 0x001,
        0x004, 0x004, 0x001, 0x001, 0x001,
    ],
    button: {
        0x000: {
            name: 'blue',
            code: 'Keyboard',
            value: 38,
            style: 'background-color:cornflowerblue'
        },
        0x001: {
            name: 'red',
            code: 'Keyboard',
            value: 40,
            style: 'background-color:red'
        },
        0x002: {
            name: 'purple',
            code: 'Keyboard',
            value: 27,
            style: 'background-color:purple'
        },
        0x003: {
            name: 'yellow',
            code: 'Keyboard',
            value: 162,
            style: 'background-color:yellow',
            content: 'R'
        },
        0x004: {
            name: 'gray',
            code: 'Keyboard',
            value: 32,
            style: 'background-color:gray',
            content: 'N'
        }
    },
    update(data, action, controller) {
        if (controller.attributes.init) {
            let x = data.beta * action.custom.sensitivity
            controller.mouseMove(x, 0)
        } else {
            controller.getMousePos((x, y) => {
                controller.attributes.ox = x
                controller.attributes.oy = y
                controller.attributes.init = true
            })
        }
    }
}
