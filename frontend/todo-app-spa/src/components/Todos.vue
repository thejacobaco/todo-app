<template>
  <v-container>
    <h1>Todos</h1>

    <v-row
      align="center"
      v-for="todo in todos"
      :key="todo.item_id"
    >
      <v-checkbox
        v-model="todo.is_done"
        true-value="y"
        false-value="n"
        @change="updateTodo(todo)"
      ></v-checkbox>
      <span :class="{'done': todo.is_done=='y'}">{{ todo.description }}</span>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Todos',
  mounted () {
    this.getTodos()
  },
  methods: {
    getTodos () {
      var vm = this
      axios.get('http://localhost:3000/todos').then(res => {
        vm.todos = res.data
      })
    },
    updateTodo (todo) {
      var vm = this
      axios.post('http://localhost:3000/todos/' + todo.item_id, todo).then(res => {
        vm.todo = res.data
      })
    },
    saveTodos () {

    }
  },
  data () {
    return {
      todos: []
    }
  }
}
</script>

<style scoped>
.done {
  text-decoration: line-through;
}
</style>
