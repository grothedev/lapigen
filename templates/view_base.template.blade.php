@extends('template')
@admin
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdn.rawgit.com/Chalarangelo/mini.css/v3.0.1/dist/mini-default.min.css"> 
<!-- <script src = "https://cdn.tailwindcss.com"></script> -->
<script src = "https://unpkg.com/vue@3"></script>
</head>

<script type = "module">
    import App from "./js/vueapp.js";
    Vue.createApp(App, { appstate: @json(App\Http\Controllers\SiteController::AppState()) }).mount('#app');
</script>

@section('content');

</html>