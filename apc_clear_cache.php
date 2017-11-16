<?php

/**
 * 
 * This file is invoked during build deployment.
 */
apc_clear_cache();
apc_clear_cache('user');
apc_clear_cache('opcode');

echo 'APC Cache Cleared.';
