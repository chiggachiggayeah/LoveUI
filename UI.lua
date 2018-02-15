local utils = require "Utils"
local Settings = require "Settings"
local UI = {}
local rubik = love.graphics.newFont("fonts/Rubik-Bold.ttf")

-- these are basically z indices
UI.registry = {}
table.insert(UI.registry, {})
table.insert(UI.registry, {})
--

function UI.Button(opts)
    local btn = {} 
    
    -- defaults
    btn.text = "Button"
    btn.color = {255, 0, 0, 255}
    btn.width = 200
    btn.height = 200
    btn.pos = {
        x = 0,
        y = 0
    }
    --

    if(opts ~= nil) then utils.attach(opts, btn) end

    -- position text relative to button
    -- btn.text.pos.x = ((btn.width - btn.text.content:getWidth()) / 2) + btn.text.pos.x
    btn.text = UI.Text({content = btn.text})
    btn.text.pos.x = ((btn.width - btn.text.content:getWidth()) / 2) + btn.pos.x
    btn.text.pos.y = ((btn.height - btn.text.content:getHeight()) / 2) + btn.pos.y

    table.insert(UI.registry[1], btn)   

    function btn:draw()
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
    end

    return btn
end

function UI.Text(opts)
    local txt = {}

    txt.content = "Hey!"
    txt.color = {255, 255, 255, 255} 
    txt.pos = {
        x = 0,
        y = 0
    }

    if (opts ~= nil) then utils.attach(opts, txt) end

    table.insert(UI.registry[2], txt)
    
    txt.content = love.graphics.newText(rubik, txt.content)

    function txt:draw()
       love.graphics.setColor(self.color) 
       love.graphics.draw(self.content, self.pos.x, self.pos.y)
    end

    return txt
end

-- can only be one registered card at a time
function UI.Card(opts)
    local card = {} 

    card.color = {100, 100, 100, 255}
    card.width = Settings.windowWidth - 100
    card.height = Settings.windowHeight - 150

    if (opts ~= nil) then utils.attach(opts, card) end

    table.insert(UI.registry[1], card) 
    local xPos = ((Settings.windowWidth - card.width) / 2)
    local yPos = 10
    function card:draw() 
        love.graphics.setColor(card.color)
        love.graphics.rectangle("fill", xPos, yPos, card.width, card.height)
    end

    return card
end

function UI.Container(opts)
    local children = {}
    local container = {}
    
    container.pos = {
        x = 0,
        y = 0
    }

    -- the width and height of the container should be
    -- whatever is necessary to "wrap" the children
    -- or "full" if that's what you specify (maybe this should be a property)
    -- think of a container more like a flex box?
    -- you evenly spread the children in the x or y
    -- children should be positioned relative to parents

    container.width = Settings.windowWidth
    container.height = Settings.windowHeight
    container.centerSpec = nil 

    if(opts ~= nil) then utils.attach(opts, container) end

    -- center
    UI:center(container, container.centerSpec) 

    function container:draw()
        for k, v in pairs(children) do
            v:draw()
        end
    end

    return setmetatable(container, {
        __call = function(childElems)
            children = childElems
        end
    })
end

function UI:TextInput(opts)
end

-- use a dsl to nest
UI.BaseScreen = {
    UI.Card {},
    UI.Container {pos = {x = 0, y = Settings.windowHeight - 100}} {
        UI.Button {
            pos = {
                x = 100,
                y = (Settings.windowHeight - 100)
            },

            width = 100,

            height = 50,

            text = "Store!"
        },
        UI.Button {
            pos = {
                x = 200,
                y = (Settings.windowHeight - 100)
            },

            width = 100,

            height = 50,

            text = "Kitchen!"
        },
        UI.Button {
            pos = {
                x = 300,
                y = (Settings.windowHeight - 100)
            },

            width = 100,

            height = 50,

            text = "Inventory!"
        }
    },
    
}

function UI:draw()
    for zindex, layer in pairs(self.registry) do
        for k, v in pairs(layer) do
            v:draw()
        end
    end
end

function UI:center(element, spec)
    local xDiff = Settings.windowWidth - element.width
    local yDiff = Settings.windowHeight - element.height

    if spec ~= nil then
        if spec == "vertical" then
            element.pos.x = (xDiff / 2)
        elseif spec == "horizontal" then
            element.pos.y = (yDiff / 2)
        end
    else
        element.pos.x = (xDiff / 2)
        element.pos.y = (yDiff / 2)
    end
end

return UI



