# Этап 1: Сборка проекта
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# Теперь эта команда 100% сработает, потому что все папки настоящие
COPY . .

# Публикуем проект, dotnet сам разберется с путями
RUN dotnet publish "Website/VedAstro.Website.csproj" -c Release -o /app/publish

# Этап 2: Запуск проекта
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "VedAstro.Website.dll"]
