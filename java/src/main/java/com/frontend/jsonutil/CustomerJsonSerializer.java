package com.frontend.jsonutil;

import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;

/**
 * depend on jackson
 * @author Diamond
 */
public class CustomerJsonSerializer {

  @Value("server.response.pretty")
  private boolean pretty;

  ObjectMapper mapper = new ObjectMapper();
  JacksonJsonFilter jacksonFilter = new JacksonJsonFilter();

  /**
   * @param clazz target type
   * @param include include fields
   * @param filter filter fields
   */
  public void filter(Class<?> clazz, String include, String filter) {
    if (clazz == null) return;
    if (StringUtils.isNotBlank(include)) {
      jacksonFilter.include(clazz, include.split(","));
    }
    if (StringUtils.isNotBlank(filter)) {
      jacksonFilter.filter(clazz, filter.split(","));
    }
    mapper.addMixIn(clazz, jacksonFilter.getClass());
  }

  public String toJson(Object object) throws JsonProcessingException {
    mapper.setFilterProvider(jacksonFilter);
    if (this.pretty) {
      return mapper.writeValueAsString(object);
    }
    return mapper.writerWithDefaultPrettyPrinter().writeValueAsString(object);
  }
  public void filter(JSON json) {
    this.filter(json.type(), json.include(), json.filter());
  }
}
