#!/usr/bin/env ruby
require 'opengl'
require 'glut'
require 'glu'

require 'homeslice_core'
require 'geometry'

class PerspectiveCamera
  def initialize(pos, target, up, options = {})
    @pos = Geometry::Point[pos]
    @target = Geometry::Point[target]
    @up = Vector[*up]
    
    @view_angle = options[:view_angle] || 60.0
    @aspect = options[:aspect] || 4/3
    @near = options[:near] || 0.1
    @far = options[:far] || 100.0
  end
  
  def move_to(new_pos)
    @pos = new_pos
  end
  
  def look_at(new_target)
    @target = new_target
  end
  
  def update_aspect(aspect)
    @aspect = aspect
  end
  
  def apply
    # set the projection matrix
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity
    gluPerspective(@view_angle, @aspect, @near, @far)
    
    #set the model view matrix
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity
    gluLookAt(
      *@pos, # eye position
      *@target, # point to look at
      *@up # direction of up
    )
  end
end

camera = PerspectiveCamera.new Geometry::Point[20, 20, 20], Geometry::Point[0, 0, 0], Vector[0, 0, 1]
test_model = Homeslice::Parser.read_file './examples/10mm_test_cube.stl'

puts test_model.min_point
puts test_model.max_point

def init
  glClearColor(1.0, 1.0, 1.0, 0)
  glColor3f(0.0, 0.0, 0.0)
end

include Gl, Glu, Glut

display = Proc.new do
  
  glClear(GL_COLOR_BUFFER_BIT)
  
  glBegin(GL_TRIANGLES)
  test_model.each_face do |face|
    glVertex(face.points[:p])
    glVertex(face.points[:q])
    glVertex(face.points[:r])
  end
  glEnd
  
  # glutWireTeapot(0.2)
  
  glutSwapBuffers
end

keyboard = Proc.new do |key, x, y|
  case key
  when ?\e, 'q'
    exit(0)
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
glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB)
glutInitWindowSize(640, 480)
glutInitWindowPosition(200, 200)
glutCreateWindow('Simple test renderer for Homeslice')

glutDisplayFunc(display)
glutReshapeFunc(reshape)
glutKeyboardFunc(keyboard)

init

glutMainLoop
