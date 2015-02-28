<?php

$repo_dir = drush_get_option('root') ? drush_get_option('root') : getcwd();
$success = drush_shell_exec('cd %s && git rev-parse --show-toplevel 2> ' . drush_bit_bucket(), $repo_dir);
if ($success) {
  $output = drush_shell_exec_output();
  $repo = $output[0];
  $options['config'] = $repo . '{{ Drupal.drush }}/drushrc.php';
  $options['include'] = $repo . '{{ Drupal.drush }}/commands';
  $options['alias-path'] = $repo . '{{ Drupal.drush }}/aliases';
}
