<div class="login-buttons">
    @auth
        <a href="{{ url('/dashboard') }}" class="text-sm text-gray-700 dark:text-gray-500 underline">Dashboard</a>
        <form method="POST" action="{{ route('logout') }}">
                @csrf
            <a href="route('logout')" onclick="event.preventDefault(); this.closest('form').submit();">Log Out</a>
        </form>
    @else
        <a href="{{ route('login') }}" class="text-sm text-gray-700 dark:text-gray-500 underline">Login</a>

        @if (Route::has('register'))
            <a href="{{ route('register') }}" class="ml-4 text-sm text-gray-700 dark:text-gray-500 underline">Register</a>
        @endif
    @endauth
</div>