let layout = [
    0x000, 0x000, 0x000, 0x000, 0x000,
    0x000, 0x000, 0x000, 0x000, 0x000,
    0x000, 0x000, 0x000, 0x000, 0x000,
    0x000, 0x000, 0x000, 0x000, 0x000,
    0x000, 0x000, 0x000, 0x000, 0x000,
    0x000, 0x000, 0x000, 0x000, 0x000,
    0x000, 0x000, 0x000, 0x000, 0x000,
    0x000, 0xFFC, 0xFFD, 0xFFE, 0xFFF,
    0x000, 0x000, 0x001, 0x002, 0x002,
    0x000, 0x000, 0x001, 0x002, 0x002,
    0x000, 0x000, 0x001, 0x002, 0x002,
]

let button = {
    0x000: {
        text: 'm-left',
        color: 'cornflowerblue',
        input: controller => controller.mouseLeftDown(),
        output: controller => controller.mouseLeftUp()
    },
    0x001: {
        text: 'm-mid',
        color: 'cornflowerblue',
        input: controller => controller.mouseMiddleDown(),
        output: controller => controller.mouseMiddleUp()
    },
    0x002: {
        text: 'm-right',
        color: 'cornflowerblue',
        input: controller => controller.mouseRightDown(),
        output: controller => controller.mouseRightUp()
    },
    0xFFC: {
        text: 'space',
        color: 'cornflowerblue',
        input: controller => controller.keyDown(controller.osType === 'Windows_NT' ? 32 : 'space'),
        output: controller => controller.keyUp(controller.osType === 'Windows_NT' ? 32 : 'space')
    },
    0xFFD: {
        text: 'enter',
        color: 'cornflowerblue',
        input: controller => controller.keyDown(controller.osType === 'Windows_NT' ? 13 : 'Return'),
        output: controller => controller.keyUp(controller.osType === 'Windows_NT' ? 13 : 'Return')
    },
    0xFFE: {
        text: 'delete',
        color: 'cornflowerblue',
        input: controller => controller.keyDown(controller.osType === 'Windows_NT' ? 8 : 'BackSpace'),
        output: controller => controller.keyUp(controller.osType === 'Windows_NT' ? 8 : 'BackSpace')
    },
    0xFFF: {
        text: 'reset',
        color: 'cornflowerblue',
        input: controller => {
            let centerX = controller.width / 2
            let centerY = controller.height / 2
            controller.mouseTo(centerX, centerY)
        }
    }
}

let keys = `a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9`.split(',')
for (let i = 0; i < keys.length; i++) {
    let key = keys[i]
    layout[i] = i + 3
    button[i + 3] = {
        text: key,
        color: 'cornflowerblue',
        input: controller => controller.keyDown(controller.osType === 'Windows_NT' ? key.toUpperCase().charCodeAt() : key),
        output: controller => controller.keyUp(controller.osType === 'Windows_NT' ? key.toUpperCase().charCodeAt() : key),
    }
}

module.exports = {
    params: {
        sensitivity: 0.5,
        vibrationReduction: 0
    },
    layout,
    button,
    update(data, controller) {
        let x = 0
        let y = 0
        let params = controller.params
        let rAlpha = Math.abs(data.rotationRateAlpha) > params.vibrationReduction ? data.rotationRateAlpha : 0
        let rGamma = Math.abs(data.rotationRateGamma) > params.vibrationReduction ? data.rotationRateGamma : 0
        if (Math.abs(data.gamma) > 45) {
            x = rAlpha * params.sensitivity
            y = rGamma * -1 * params.sensitivity
        } else {
            x = rGamma * -1 * params.sensitivity
            y = rAlpha * -1 * params.sensitivity
        }
        controller.mouseMove(x, y)
    }
}
