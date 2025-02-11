document.addEventListener 'DOMContentLoaded', ->
  tasks = document.querySelectorAll('.draggable')
  columns = document.querySelectorAll('.droppable')
  
  tasks.forEach (task) ->
    task.setAttribute('draggable', true)

    task.addEventListener 'dragstart', (e) ->
      e.dataTransfer.setData('text/plain', e.target.dataset.id)
      e.target.classList.add('dragging')

    task.addEventListener 'dragend', (e) ->
      e.target.classList.remove('dragging')


  columns.forEach (column) ->
    column.addEventListener 'dragover', (e) ->
      e.preventDefault()
            
    column.addEventListener 'drop', (e) ->
      e.preventDefault()
      taskId = e.dataTransfer.getData('text/plain')
      task = document.querySelector(".draggable[data-id='#{taskId}']")
      return unless task
      return unless e.currentTarget
      columnId = e.currentTarget.dataset.columnId

      fetch "/tasks/#{taskId}",
        method: 'PATCH'
        headers:
          'Content-Type': 'application/json'
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        body: JSON.stringify(task: { column_id: columnId })

      .then (response) ->
        if response.ok
          response.json()
        else
          throw new Error('Failed to update task')
      .then (data) ->
        # console.log("Data: ", data)
        updateTaskUI(task, columnId)
      .catch (error) ->
        console.error('Drag and drop error:', error)
        revertTask(task)

updateTaskUI = (task, columnId) ->
  targetColumn = document.querySelector(".tasks-container[data-column-id='#{columnId}']")
  
  if targetColumn
    targetColumn.appendChild(task)
    task.dataset.columnId = columnId

revertTask = (task) ->
  originalColumnContainer = task.closest('.column')
  if originalColumnContainer
    originalContainer = originalColumnContainer.querySelector('.tasks-container')
    originalContainer?.appendChild(task)