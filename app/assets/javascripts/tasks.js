(function() {
  var revertTask, updateTaskUI;

  document.addEventListener('DOMContentLoaded', function() {
    var columns, tasks;
    tasks = document.querySelectorAll('.draggable');
    columns = document.querySelectorAll('.droppable');
    tasks.forEach(function(task) {
      task.setAttribute('draggable', true);
      task.addEventListener('dragstart', function(e) {
        e.dataTransfer.setData('text/plain', e.target.dataset.id);
        return e.target.classList.add('dragging');
      });
      return task.addEventListener('dragend', function(e) {
        return e.target.classList.remove('dragging');
      });
    });
    return columns.forEach(function(column) {
      column.addEventListener('dragover', function(e) {
        return e.preventDefault();
      });
      return column.addEventListener('drop', function(e) {
        var columnId, task, taskId;
        e.preventDefault();
        taskId = e.dataTransfer.getData('text/plain');
        task = document.querySelector(`.draggable[data-id='${taskId}']`);
        if (!task) {
          return;
        }
        if (!e.currentTarget) {
          return;
        }
        columnId = e.currentTarget.dataset.columnId;
        return fetch(`/tasks/${taskId}`, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({
            task: {
              column_id: columnId
            }
          })
        }).then(function(response) {
          if (response.ok) {
            return response.json();
          } else {
            throw new Error('Failed to update task');
          }
        }).then(function(data) {
          // console.log("Data: ", data)
          return updateTaskUI(task, columnId);
        }).catch(function(error) {
          console.error('Drag and drop error:', error);
          return revertTask(task);
        });
      });
    });
  });

  updateTaskUI = function(task, columnId) {
    var targetColumn;
    targetColumn = document.querySelector(`.tasks-container[data-column-id='${columnId}']`);
    if (targetColumn) {
      targetColumn.appendChild(task);
      return task.dataset.columnId = columnId;
    }
  };

  revertTask = function(task) {
    var originalColumnContainer, originalContainer;
    originalColumnContainer = task.closest('.column');
    if (originalColumnContainer) {
      originalContainer = originalColumnContainer.querySelector('.tasks-container');
      return originalContainer != null ? originalContainer.appendChild(task) : void 0;
    }
  };

}).call(this);


//# sourceMappingURL=tasks.js.map
//# sourceURL=coffeescript