<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
import ip from 'ip'
export default {
  name: 'main',
  data () {
    return {
      ip: ip.address()
    }
  }
}
</script>
