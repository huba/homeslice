#!/usr/bin/env ruby
require 'opengl'
require 'glut'
require 'glu'

require 'homeslice_core'
require 'geometry'

include Gl, Glu, Glut

class PerspectiveCamera
  attr_reader :pos
  
  def initialize(pos, target, up, options = {})
    @pos = Geometry::Point[pos]
    @target = Geometry::Point[target]
    @up = Vector[*up]
    
    @view_angle = options[:view_angle] || 60.0
    @aspect = options[:aspect] || 4/3
    @near = options[:near] || 0.1
    @far = options[:far] || 200.0
  end
  
  def move_to(new_pos)
    @pos = new_pos
    glutPostRedisplay
  end
  
  def look_at(new_target)
    @target = new_target
    glutPostRedisplay
  end
  
  def orbit(deg)
    angle = deg / 180 * Math::PI
    rotation = Matrix[
      [Math.cos(angle) ,  Math.sin(angle), 0, @target.x],
      [-Math.sin(angle), Math.cos(angle) , 0, @target.y],
      [0               , 0               , 1, @target.z],
      [0               , 0               , 0, 1        ]
    ]
    
    pos_offset = @pos - @target
    new_pos = rotation * Vector[*pos_offset, 1]
    move_to Geometry::Point[new_pos[0], new_pos[1], new_pos[2]]
  end
  
  def change_height(delta)
    move_to Geometry::Point[@pos.x, @pos.y, @pos.z + delta]
  end
  
  def update_aspect(aspect)
    @aspect = aspect
    glutPostRedisplay
  end
  
  def apply
    # set the projection matrix
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity
    gluPerspective(@view_angle, @aspect, @near, @far)
    
    #set the model view matrix
    glMatrixMode(GL_MODELVIEW)
    gluLookAt(
      *@pos, # eye position
      *@target, # point to look at
      *@up # direction of up
    )
    
  end
end

camera = PerspectiveCamera.new Geometry::Point[00, 00, 40], Geometry::Point[50, 50, 0], Vector[0, 0, 1]
test_model = Homeslice::Parser.read_file './examples/naroznik.stl'

puts "Model goes from height #{test_model.min_point.z}mm to #{test_model.max_point.z}mm."
if test_model.has_free_edges?
  puts "Model has holes."
else
  puts "Model is completely closed."
end

#moves the center to x, y
def render_model(model, cam, x, y)
  size = model.max_point - model.min_point
  
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity
  cam.apply
  glTranslate -model.min_point.x - size.x/2 + x, -model.min_point.y - size.x/2 + y, - model.min_point.z
  
  glBegin(GL_TRIANGLES)
  model.each_face do |face|
    glVertex(face.points[:p])
    glVertex(face.points[:q])
    glVertex(face.points[:r])
  end
  glEnd
end

def init
  # fogColor = [0.0, 0.0, 0.0, 1.0]

  # glEnable(GL_FOG)
  # glFog(GL_FOG_MODE, GL_LINEAR)
  # glHint(GL_FOG_HINT, GL_NICEST)  # per pixel
  # glFog(GL_FOG_START, 50.0)
  # glFog(GL_FOG_END, 150.0)
  # glFog(GL_FOG_COLOR, fogColor)
  glClearColor(1.0, 1.0, 1.0, 1.0)
  
  ambient = [ 0.1, 0.1, 0.1, 1.0 ]
  diffuse = [ 1.0, 1.0, 1.0, 1.0 ]
  position = [ 50.0, 50.0, 100.0, 0.0 ]
  lmodel_ambient = [ 0.4, 0.4, 0.4, 1.0 ]
  local_view = [ 0.0 ]
  
  glLight(GL_LIGHT0, GL_AMBIENT, ambient)
  glLight(GL_LIGHT0, GL_DIFFUSE, diffuse)
  glLight(GL_LIGHT0, GL_POSITION, position)
  glLightModel(GL_LIGHT_MODEL_AMBIENT, lmodel_ambient)
  glLightModel(GL_LIGHT_MODEL_LOCAL_VIEWER, local_view)

  glEnable(GL_LIGHTING)
  glEnable(GL_LIGHT0)

  glDepthFunc(GL_LESS)
  glEnable(GL_DEPTH_TEST)
  glEnable(GL_CULL_FACE)
  # glEnable(GL_COLOR_MATERIAL)
  glShadeModel(GL_SMOOTH)
end

display = Proc.new do
  # glPolygonMode(GL_FRONT, GL_FILL)
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
  
  no_mat = [ 0.0, 0.0, 0.0, 1.0 ]
  mat_ambient = [ 0.7, 0.7, 0.7, 1.0 ]
  mat_ambient_color = [ 0.8, 0.8, 0.2, 1.0 ]
  mat_diffuse = [ 0.1, 0.5, 0.8, 1.0 ]
  mat_specular = [ 1.0, 1.0, 1.0, 1.0 ]
  no_shininess = [ 0.0 ]
  low_shininess = [ 5.0 ]
  high_shininess = [ 100.0 ]
  mat_emission = [0.3, 0.2, 0.2, 0.0]
  
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity
  camera.apply
  
  # glMaterial(GL_FRONT, GL_AMBIENT, no_mat)
  # glMaterial(GL_FRONT, GL_DIFFUSE, no_mat)
  glMaterial(GL_FRONT, GL_SPECULAR, no_mat)
  # glMaterial(GL_FRONT, GL_SHININESS, no_shininess)
  # glMaterial(GL_FRONT, GL_EMISSION, no_mat)
  
  glColor3f(0.4, 0.4, 0.4)
  glBegin(GL_LINES)
  gap = 1.0
  count = 100
  
  (0..count).each do |n|
    glVertex(n * gap, 0, 0)
    glVertex(n * gap, count, 0)
  end
  
  (0..count).each do |n|
    glVertex(0, n * gap, 0)
    glVertex(count, n * gap, 0)
  end
  glEnd
  
  # glMaterial(GL_FRONT, GL_AMBIENT, mat_ambient)
  glMaterial(GL_FRONT, GL_DIFFUSE, mat_diffuse)
  glMaterial(GL_FRONT, GL_SPECULAR, mat_specular)
  # glMaterial(GL_FRONT, GL_SHININESS, no_shininess)
  # glMaterial(GL_FRONT, GL_EMISSION, no_mat)
  
  glColor3f(0.1, 0.1, 0.1)
  render_model(test_model, camera, 50, 50)
  # render_model(test_model, camera, 40, 40)
  
  glutSwapBuffers
end

keyboard = Proc.new do |key, x, y|
  case key
  when ?\e, 'q'
    exit(0)
  when 'h'
    camera.orbit(20)
  when 'j'
    camera.change_height(-5)
  when 'k'
    camera.change_height(5)
  when 'l'
    camera.orbit(-20)
  # when 'r'
  #   camera = PerspectiveCamera.new Geometry::Point[20, 20, 20], Geometry::Point[0, 0, 0], Vector[0, 0, 1]
  #   camera.apply
  end
end


reshape = Proc.new do |width, height|
  aspect = width / height
  size = 2
  
  glViewport(0, 0, width, height)
  camera.update_aspect(aspect)
  camera.apply
end

glutInit
glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH)
glutInitWindowSize(640, 480)
glutInitWindowPosition(200, 200)
glutCreateWindow('Simple test renderer for Homeslice')

init

glutDisplayFunc(display)
glutReshapeFunc(reshape)
glutKeyboardFunc(keyboard)


glutMainLoop
