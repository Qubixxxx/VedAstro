# Этап 1: Сборка проекта
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# Копируем только файл проекта Website. В нем содержится список всех зависимостей.
COPY Website/VedAstro.Website.csproj ./Website/

# ЗАПУСКАЕМ ВОССТАНОВЛЕНИЕ ЗАВИСИМОСТЕЙ.
# dotnet увидит, что нужна библиотека VedAstro.Library, найдет ее в NuGet
# и скачает автоматически. Нам больше не нужна папка /src.
RUN dotnet restore "./Website/VedAstro.Website.csproj"

# Теперь, когда зависимости скачаны, копируем все остальные файлы проекта Website
COPY Website/ ./Website/

# Публикуем проект
RUN dotnet publish "./Website/VedAstro.Website.csproj" -c Release -o /app/publish

# Этап 2: Запуск проекта
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "VedAstro.Website.dll"]
