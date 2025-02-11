Column.destroy_all

Column.create([
  { name: 'To Do' },
  { name: 'In Progress' },
  { name: 'Done' }
])

todo = Column.find_by(name: 'To Do')
in_progress = Column.find_by(name: 'In Progress')
done = Column.find_by(name: 'Done')

Task.create([
  { title: 'First Task', description: 'Initial task in To Do', column: todo },
  { title: 'Ongoing Work', description: 'Task in progress', column: in_progress },
  { title: 'Completed Task', description: 'Finished task', column: done }
])