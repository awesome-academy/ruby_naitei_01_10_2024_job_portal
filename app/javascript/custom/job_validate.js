import { t } from "./translations";

document.addEventListener("DOMContentLoaded", function() {
  const form = document.querySelector("#enterprise_job_form");
  if (!form) return;
  form.addEventListener("submit", function(event) {
    let isValid = true;
    const title = form.querySelector("input[name='job[title]']");
    const location = form.querySelector("input[name='job[location]']");
    const description = form.querySelector("textarea[name='job[description]']");
    const experienceLevel = form.querySelector("select[name='job[experience_level]']");
    const salaryRange = form.querySelector("input[name='job[salary_range]']");
    const workType = form.querySelector("select[name='job[work_type]']");
    const status = form.querySelector("select[name='job[status]']");
    
    const errorMessages = form.querySelectorAll(".error-message");
    errorMessages.forEach(msg => msg.remove());

    if (!title.value) {
      isValid = false;
      showError(title, t("blank_error"));
    } else if (title.value.length > 100) {
      isValid = false;
      showError(title, t("length_too_long_error"));
    }

    if (!location.value) {
      isValid = false;
      showError(location, t("blank_error"));
    }

    if (!description.value) {
      isValid = false;
      showError(description, t("blank_error"));
    } else if (description.value.length > 1000) {
      isValid = false;
      showError(description, t("length_too_long_error"));
    }

    if (!experienceLevel.value) {
      isValid = false;
      showError(experienceLevel, t("blank_error"));
    }

    if (!salaryRange.value) {
      isValid = false;
      showError(salaryRange, t("blank_error"));
    }

    if (!workType.value) {
      isValid = false;
      showError(workType, t("blank_error"));
    }

    if (!status.value) {
      isValid = false;
      showError(status, t("blank_error"));
    }

    if (!isValid) {
      event.preventDefault();
    }
  });

  function showError(input, message) {
    const errorMessage = document.createElement("div");
    errorMessage.className = "error-message text-danger";
    errorMessage.innerText = message;
    input.parentNode.appendChild(errorMessage);
  }
});
