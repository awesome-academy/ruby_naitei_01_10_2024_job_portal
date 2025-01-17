// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "custom/menu"
import "custom/step_modal"
import "custom/datepicker"
import "custom/job_validate"
import "custom/translations"
import "bootstrap"
import "flatpickr"
import "nouislider"

import { loadTranslations } from "./custom/translations";

document.addEventListener("turbo:load", function() {
  const locale = getCookie("locale");
  loadTranslations(locale);
});

function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
  return null;
}
