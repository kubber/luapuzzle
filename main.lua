function love.load()
  width = 640
  height = 480
  love.window.setMode(width, height)
  states = {GAME="GAME", MENU="MENU", END="END"}
  state = states.MENU 
  sprites = {"tiger.jpg", "panda.jpg", "elephant.jpg"}
  img = nil
  level = 1
  winSound = love.audio.newSource("sounds/tiger.wav", "static")
  video = love.graphics.newVideo("videos/track.ogv")
  backgroundMusic = love.audio.newSource("sounds/music.ogg", "stream")
  backgroundMusic:setLooping(true)
  backgroundMusic:play()
  
  levels = {160, 80, 40}
  size = levels[1]
  columns = 0
  rows = 0
  puzzles = {} 
  makePuzzles(size)
end 

function makePuzzles(size)
  img = love.graphics.newImage('sprites/'..sprites[level])
  columns = math.ceil(width/size)
  rows = math.ceil(height/size) 

  for i=1, columns do  
    puzzles[i] = {}
    for j=1, rows do
      puzzles[i][j] = {}
      puzzles[i][j].img = love.graphics.newQuad((i-1)*size,(j-1)*size,size,size, img:getDimensions())
      puzzles[i][j].rotation = math.random(1,3)*math.rad(90)
    end
  end
end 


function menu()
  love.graphics.setNewFont(24)
  love.graphics.printf("Click anywhere to start!", 0, 380, width, "center")
  video:play()
  love.graphics.draw(video, 0, 0)
end


function game()
 for i=1, columns do 
   for j=1, rows do
      love.graphics.draw(img, puzzles[i][j].img, (i-1)*size + size/2, (j-1)*size + size/2, puzzles[i][j].rotation, 1, 1, size/2, size/2)
   end 
  end 
end


function endGame()
  love.graphics.setNewFont(30)
  love.graphics.printf("Level ".. level .. " DONE! Click to start next one. It's getting more difficult each time!", 0, height/3, width, "center")
  backgroundMusic:stop()
  winSound:play()
end 


function love.draw()    
  if state == states.MENU then
    menu()
  elseif state == states.GAME then 
    game()
  elseif state == states.END then 
    endGame()
  end
end


function love.mousepressed(x, y, button, istouch, presses)
  if state == states.MENU then 
    state = states.GAME
  elseif state == states.GAME then 

    x1 = math.floor(x/size) + 1
    y1 = math.floor(y/size) + 1
    puzzles[x1][y1].rotation = (puzzles[x1][y1].rotation + math.rad(90)) % math.rad(360)
  
    sum = 0 
    for i=1, columns do 
      for j=1, rows do
        sum = sum + puzzles[i][j].rotation
      end 
    end  
    if sum == 0 then 
      state = states.END
    end 
  elseif state == states.END then 
    level = level + 1 
    if level <= table.getn(levels) then
      size = levels[level] 
      makePuzzles(size) 
      backgroundMusic:play()
      state = states.GAME 
    else
      level = 1
      state = states.MENU
    end 
  end
end
